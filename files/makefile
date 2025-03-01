# Configuración
REPO = https://github.com/memcached/memcached.git
VERSION = 1.6.37
PREFIX = $(HOME)/local
LOG_AUTOGEN = ../logs/autogen.log
LOG_CONF_HELP = ../logs/configure-help.log
LOG_CONF = ../logs/configure.log
LOG_MAKE = ../logs/make.log
LOG_MAKE_INSTALL = ../logs/make-install.log
LOG_MEMC_HELP = ../logs/memcached-help.log

.PHONY: all clean
.PHONY: test

all: install
	@echo "\n=== Verificación final ==="
	@which memcached || echo "Error en la instalación"
	@file $(PREFIX)/bin/memcached
	@$(PREFIX)/bin/memcached --help >> $(LOG_MEMC_HELP) 2>&1
	@echo "¡Proceso completado!

# Descarga y preparación del código
clone:
	@if [ ! -d "memcached" ]; then \
		echo "Clonando repositorio..." && \
		git clone $(REPO) && \
		cd memcached && \
		echo "Versiones disponibles:" && git tag -l | sort -V | tail -n 5; \
	else \
		echo "El repositorio ya está clonado"; \
	fi

checkout: clone
	@cd memcached && \
	echo "Cambiando a la versión $(VERSION)" && \
	git checkout $(VERSION)

# Dependencias
deps:
	@echo "Instalando dependencias..."
	sudo apt update && sudo apt install -y \
		tree \
		pkg-config \
		libssl-dev \
		libevent-dev \
		libseccomp-dev \
		automake \
		autoconf \
		libtool \
		net-tools

# Configuración
configure: checkout deps
	@cd memcached && \
	echo "\n=== Ejecutando autogen.sh ===" && \
	./autogen.sh >> ../$(LOG_AUTOGEN) 2>&1 && \
	echo "Autogen exitoso (código $$?)" && \
	ls -l configure && \
	echo "\n=== Opciones de configure ===" && \
	./configure --help >> ../$(LOG_CONF_HELP) 2>&1 && \
	echo "\n=== Ejecutando configure ===" && \
	./configure --prefix=$(PREFIX) >> ../$(LOG_CONF) 2>&1 && \
	ls -l Makefile

# Compilación e instalación
build: configure
	@cd memcached && \
	echo "\n=== Compilando ===" && \
	make >> ../$(LOG_MAKE) 2>&1

install: build
	@cd memcached && \
	echo "\n=== Instalando ===" && \
	make install >> ../$(LOG_MAKE_INSTALL) 2>&1 && \
	echo "\n=== Archivos instalados ===" && \
	find $(PREFIX) -ls && \
	tree -a $(PREFIX)

# Limpieza
clean:
	rm -rf memcached
	@echo "Directorio de instalación: $(PREFIX) (no se borra automáticamente)"

test:
	@chmod +x pruebas.sh
	@./pruebas.sh
	@echo "pruebas ejecutadas, ver logs en pruebas.log"
