RUN = bin/$(@).sh

ALLDEPS = ost-controller k8s-controller k8s-worker-preflight k8s-worker ost-controller-postinstall tunnelzone pingcheck

OST_CONTROLLER = 95.85.54.195
K8S_CONTROLLER = 95.85.54.199

K8S_WORKERS = 95.85.54.205 95.85.55.10 95.85.55.51

all: $(ALLDEPS)

ost-controller:
	$(RUN) $(OST_CONTROLLER)

k8s-controller:
	$(RUN) $(K8S_CONTROLLER) $(OST_CONTROLLER)

k8s-worker-preflight:
	for K8S_WORKER in $(K8S_WORKERS); do $(RUN) "$${K8S_WORKER}" || exit 1; done

k8s-worker:
	for K8S_WORKER in $(K8S_WORKERS); do $(RUN) "$${K8S_WORKER}" $(OST_CONTROLLER) $(K8S_CONTROLLER); echo; done

ost-controller-postinstall:
	$(RUN) $(OST_CONTROLLER)

tunnelzone:
	$(RUN) $(OST_CONTROLLER)

reboot:
	$(RUN) $(OST_CONTROLLER) $(K8S_CONTROLLER) $(K8S_WORKERS)

pingcheck:
	ssh core@$(OST_CONTROLLER) -t -- ping -c 3 172.16.0.1
