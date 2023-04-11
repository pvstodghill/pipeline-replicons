# pipeline-FIXME

Pipeline for FIXME

## Cloning the repo

This pipeline uses Git submodules. The easiest way to clone this repo
(with a recent version of `git`) is

```
git clone --recurse-submodules https://github.com/pvstodghill/pipeline-FIXME.git
```

## Installing prereqs

You will want to install one of the following:

- [Docker](https://www.docker.com/)
- [Singularity](https://sylabs.io/)
- [Apptainer](https://apptainer.org/)
- [Conda](https://conda.io)

You will also need,

- [Perl](https://www.perl.org/)
- [Perl's YAML module](https://metacpan.org/dist/YAML)

## Configuring the pipeline

**Create the configuration files**

For the `example` data,

1. Copy `example/config.bash` to  `config.bash`.
2. Optionally, copy `example/config08.bash` to  `config08.bash`.

To run the pipeline on your own data,

1. Copy `config.template.bash` to `config.bash`.  Edit `config.bash`
   according to your needs and local environment.
2. Optionally,  `config08.template.bash` to `config08.bash` and edit.

**Choose how to access packages.**

 Do one of the following,

1. For strong reproducibility, use with the provided Docker (or
   equivalent Signularity or Apptainer) packages with explicit
   versions:

    * Edit `config.bash`
    * Uncomment `PACKAGES_FROM=howto`


1. For convenience(?), flexibility(?), use Conda to use the latest
   package versions.

    * Create a Conda environment with the necessary packages, perhaps
      using `conda-setup.bash`.
    * Edit `config.bash`
    * Uncomment `PACKAGES_FROM=conda`
    * Uncomment and set `CONDA_ENV=...`

## Running the pipeline

1. `./doit00-init.bash`
2. `./doit01-FIXME.bash`
3. ...
