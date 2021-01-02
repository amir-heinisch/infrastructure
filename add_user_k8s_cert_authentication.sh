#!/bin/sh

CLUSTER="kubernetes"
USERNAME="testuser"
# Just add /O=groupname if needed.
# Use oidc: prefix to be compliant to our oidc rolebindings.
GROUPS="/O=oidc:<team_name>"
NAMESPACE="<team_name>-dev"

KEYFILE="$USERNAME.key"
CSRFILE="$USERNAME.csr"
CERTFILE="$USERNAME.crt"

# Generate rsa key and signing request.
openssl genrsa -out $KEYFILE 4096
openssl req -new -key $KEYFILE -out $CSRFILE -subj "/CN=$USERNAME$GROUPS"

# Create k8s certificate signing request.
echo "
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: $USERNAME_$NAMESPACE
spec:
  groups:
  - system:authenticated
  request: $(cat $CSRFILE | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
  - client auth
" > csr.yaml

# Upload request to k8s.
kubectl apply -f csr.yaml

# Approve certificate.
kubectl certificate approve $USERNAME_$NAMESPACE

# Get signed certificate.
kubectl get csr $USERNAME_$NAMESPACE -o json | jq -r .status.certificate | base64 -d > $CERTFILE

# Tell kubectl to use the new certificate to authenticate to the cluster/namespace.
kubectl config set-credentials testuser --client-certificate=$(pwd)/$CERTFILE --client-key=$(pwd)/$KEYFILE
kubectl config set-context $USERNAME-context --cluster $CLUSTER --namespace $NAMESPACE --user $USERNAME
