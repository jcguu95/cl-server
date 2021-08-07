prefix=${HOME}/.local/bin
target=${prefix}/lisp

all:

install_client:
	cp ./lisp ${target}

uninstall_client:
	rm ${target}

install: install_client

uninstall: uninstall_client
