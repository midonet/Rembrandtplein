RUN = bin/$(@).sh

ALLDEPS = ost-controller k8s-controller k8s-worker ost-controller-postinstall tunnelzone pingcheck

OST_CONTROLLER = 192.168.9.11
K8S_CONTROLLER = 192.168.9.13

K8S_WORKERS = 192.168.9.15 192.168.9.16 192.168.9.17

all: $(ALLDEPS)

ost-controller:
	$(RUN) $(OST_CONTROLLER)

k8s-controller:
	$(RUN) $(K8S_CONTROLLER) $(OST_CONTROLLER)

k8s-worker:
	for K8S_WORKER in $(K8S_WORKERS); do $(RUN) "$${K8S_WORKER}" $(OST_CONTROLLER) $(K8S_CONTROLLER); echo; done

ost-controller-postinstall:
	$(RUN) $(OST_CONTROLLER)

tunnelzone:
	$(RUN) $(OST_CONTROLLER)

pingcheck:
	ssh core@$(OST_CONTROLLER) -t -- ping -c 3 172.16.0.1
