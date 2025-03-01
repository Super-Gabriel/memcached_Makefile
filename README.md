### Makefile para la instalación de memcached

#### Pre requisitos

Debemos agregar el directorio home/local/bin a la variable de entorno PATH:

- `nano ~/.bashrc` 
- agregar al final la linea: `export PATH="$HOME/local/bin:$PATH"`

#### instalación

Debemos situarnos en el directorio del archivo `makefile`

- el archivo está en files: `cd files`
- ejecutar `make install`

#### notas

- en el directorio `ownLogs` se encuentran los logs generados por nosotros, pero al hacer `make install` se generaran los logs en el directorio `logs`
