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

2. Install Jupyter Book

    ```
    pip install jupyter-book
    ```

3. Create or update your Jupyter Notebooks locally using your favorite notebook editor.

4. Once you made your changes, now you can build the Jupyter Notebook HTML

    ```
    jupyter-book build .
    ```

5. Once built, you should be able to paste the file path (e.g. `file://path/to/data-exploration/_build/html/index.html`) displayed in the output into your browser bar to preview it.  Make any changes necessary and re-run steps 3 and 4.

6. Once you are ready to publish, you will need to add an empty file called `.nojekll` to the folder `./_build/html/`. This will tell Github not to interpret this as a Jekyll site.

    Then commit and push your changes to the main branch

    ```
    git push origin master
    ```

    And then push the generated HTML subfolder to the gh-site branch

    ```
    git subtree push --prefix _build/html origin gh-site
    ```

    This should trigger an automatic re-build of the changed Github Pages webpages.  You should be able to see the status of those builds in the ["Actions"](https://github.com/LibraryOfCongress/data-exploration/actions) section of the repository. And once deployed, view the final result on [Github Pages](https://LibraryOfCongress.github.io/data-exploration/).