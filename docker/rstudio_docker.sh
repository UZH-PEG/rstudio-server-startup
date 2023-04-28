#!/bin/sh
docker run \
	--interactive \
	--tty \
	--rm \
	--cpus=7 \
	--memory=50GB \
	--memory-swap=-1 \
	--publish 8787:8787 \
	--env PASSWORD=password \
	--env ROOT=true \
	\
	--volume /Users/rainer/R/dockerlib:/opt/R/library \
	--env R_LIBS=/opt/R/library \
	--volume $(pwd)/rsession.conf:/etc/rstudio/rsession.conf \
	\
	--volume /Users/rainer/R/rstudio:/home/rstudio/ \
	--volume /Users/rainer/Documents:/home/rstudio/Documents \
	--volume /Users/rainer/git:/home/rstudio/git \
	rocker/verse:4.2.3
	
	
#!/bin/bash
# docker run -ti  \
#   -p 8787:8787 \
#   -e PASSWORD=yourpasswordhere \
#   -v /Users/rainerkrug:/home/rstudio/local \
#   -v /Users/rainerkrug/R/docker/library:/usr/local/lib/R/site-library \
#   rocker/verse:4.2.3
  