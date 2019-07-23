FROM jupyter/datascience-notebook:7a3e968dd212@sha256:48e30b6ccf0ed5c8359197af34e1b2a3819cc07f16e22ca307cf9d305f60e63a

COPY FinalTestingBoxLatency /home/$NB_USER/work/FinalTestingBoxLatency
COPY test_notebook.ipynb /home/$NB_USER/work/
