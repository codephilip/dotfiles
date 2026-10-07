# Docker Commands

d         → docker
dc        → docker compose
ld        → lazydocker (TUI: x lists keys, q quits)
Ctrl-O    → lazydocker, straight from the prompt

## Containers
dps       → docker ps
dpa       → docker ps -a
dst       → stats

## Images
di        → images

## Logs / Exec
dl        → logs
dlf       → follow logs
dex       → exec -it

## Build / Run
db        → build
dr        → run
drm       → rm
drmi      → rmi

## Compose
dcu       → compose up
dcud      → compose up -d
dcd       → compose down
dcb       → compose build
dcl       → compose logs
dclf      → follow compose logs

## Cleanup
dclean    → system prune
dcleanf   → prune all unused images too (no prompt)
dkclean   → …and unused VOLUMES — deletes data (no prompt)
