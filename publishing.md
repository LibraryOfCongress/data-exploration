# Instructions for publishing notebooks

This page is for repository maintainers and will document how to edit and publish these notebooks to [Github Pages](https://LibraryOfCongress.github.io/data-exploration/).

## Pre-requisites

You will need at least [Git](https://git-scm.com/) and [Python](https://www.python.org/) installed on your machine.

And you will need read and write access to [the Github repository](https://github.com/LibraryOfCongress/data-exploration) unless you are forking this repository to your own. Please contact the site admin for access.

## Steps

1. Clone this repository to your local machine

    ```
    git clone https://github.com/LibraryOfCongress/data-exploration.git
    cd data-exploration
    ```

2. Install Jupyter Book - Version 1 is required, Version 2 has breaking changes; 1.0.4 is the last stable V1

    ```
    pip install "jupyter-book==1.0.4"
    ```

3. Create or update your Jupyter Notebooks locally using your favorite notebook editor.

4. Once you made your changes, now you can build the Jupyter Notebook HTML locally to see what it looks like

    ```
    jupyter-book build .
    ```

    You can also signal a full re-build using the `--all` option:

    ```
    jupyter-book build --all .
    ```

    Or you can manually delete the `_build/html` folder to build fresh

5. Once built, you should be able to paste the file path (e.g. `file://path/to/data-exploration/_build/html/index.html`) displayed in the output into your browser bar to preview it.  Make any changes necessary and re-run steps 3 and 4.

6. Once you are ready to publish, simply push or merge your changes into the `master` branch. This will trigger a re-build on Github Pages.

    You should be able to see the status of this build in the ["Actions"](https://github.com/LibraryOfCongress/data-exploration/actions) section of the repository. And once deployed, view the final result on [Github Pages](https://LibraryOfCongress.github.io/data-exploration/).