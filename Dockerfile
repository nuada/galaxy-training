FROM bgruening/galaxy-stable:dev

MAINTAINER Piotr Radkowski <piotr.radkowski@uj.edu.pl>

ENV GALAXY_HOME /galaxy-central
ENV GALAXY_CONFIG_BRAND OMICRON Workshop 2015

WORKDIR ${GALAXY_HOME}

# Install tools
RUN service postgresql start && ./run.sh --daemon && \
	until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do echo -n .; sleep 4; done && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o devteam --name suite_samtools_0_1_19 --panel-section-name SAMTools && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o devteam --name freebayes --panel-section-name Freebayes && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o devteam --name bowtie2 --panel-section-name Mapping && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o devteam --name fastqc --panel-section-name "Quality Control" && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_pysam_0_7_7 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o devteam --name package_libpng_1_6_7 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_freetype_2_4 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_numpy_1_7 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_scipy_0_12 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_matplotlib_1_2 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_bx_python_12_2013 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o crs4 --name bwa_mem  --panel-section-name Mapping && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name vt_variant_tools --panel-section-name VCFTools && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o anton --name suite_vcflib_tools_2_0 --panel-section-name VCFTools && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name snpeff --panel-section-name SNPEff && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_tabix_0_2_6 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_bedtools_2_19 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_grabix_0_1_3 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://testtoolshed.g2.bx.psu.edu/ -o iuc --name bedtools --panel-section-name BEDtools && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://testtoolshed.g2.bx.psu.edu/ -o lparsons --name package_cutadapt_1_6 && \
	python ./scripts/api/install_tool_shed_repositories.py --api admin -l http://localhost:8080 --tool-deps --repository-deps --url http://testtoolshed.g2.bx.psu.edu/ -o lparsons --name cutadapt --panel-section-name Trimming && \
	./run.sh --stop-daemon && service postgresql stop

# Setup location files
ENV RESOURCES /resources/hg19
ENV REFERENCE ucsc.hg19.fasta
ADD tool_data_table_conf.xml ${GALAXY_HOME}/config/
RUN echo "hg19.ucsc\thg19\tHuman (Homo sapiens): hg19 UCSC\t${RESOURCES}/${REFERENCE}" >> \
			${GALAXY_HOME}/tool-data/all_fasta.loc && \
	echo "hg19.ucsc\thg19\tHuman (Homo sapiens): hg19 UCSC\t${RESOURCES}/${REFERENCE}" >> \
		${GALAXY_HOME}/tool-data/fasta_indexes.loc && \
	echo "hg19.ucsc\thg19\tHuman (Homo sapiens): hg19 UCSC\t${RESOURCES}/bowtie/hg19" >> \
		${GALAXY_HOME}/tool-data/bowtie2_indices.loc && \
	echo "hg19.ucsc\thg19\tHuman (Homo sapiens): hg19 UCSC\t${RESOURCES}/bwa/0.7.5/${REFERENCE}" >> \
		${GALAXY_HOME}/tool-data/bwa_index.loc && \
	echo "SnpEff4.0_hg19\tSnpEff4.0\thg19\tHomo sapiens : hg19" >> \
		${GALAXY_HOME}/tool-data/snpeffv_databases.loc && \
	echo "SnpEff4.0_hg19\tSnpEff4.0\thg19\tHomo sapiens : hg19\t/resources/snpEff/4.0" >> \
		${GALAXY_HOME}/tool-data/snpeffv_genomedb.loc && \
	sed -i '/^#tool_data_table_config_path/ s/^#//' /etc/galaxy/galaxy.ini

# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy), 9001 (Galaxy report app)
EXPOSE 80 21 8800 9001

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
