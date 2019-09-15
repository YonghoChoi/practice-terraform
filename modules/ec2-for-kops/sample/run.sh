#!/bin/bash
until sudo kubectl get nodes &> /dev/null
do
    echo "Waiting for provisioning kubernetes ..."
    sleep 5
done
echo "provisioning complete!"