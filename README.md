# [Markdown Tables](http://markdowntables.com)

Create, Edit and Format your markdown tables.

Similar to these projects:

+ [Markdown table generator](https://jakebathman.github.io/Markdown-Table-Generator/)
+ [tablesgenerator.com](https://www.tablesgenerator.com/markdown_tables)

... but much better.

# Running app locally

```bash
git clone git@github.com:samhstn/markdowntables.git && cd markdowntables
npm install
npm start
```

# Running app in production

We have configured travis to automatically deploy to `gh-pages` branch.

To set this up, we simply need to generate a new token with a `repo` scope in our [github developer settings](https://github.com/settings/tokens).

Then add this token as an environment variable called `GITHUB_TOKEN` in our [travis settings](https://travis-ci.org/samhstn/markdowntables/settings).

Every change to our `master` branch will trigger a new deploy to our `gh-pages` url.

A useful script to wait for `gh-pages` to be deployed is:

```bash
until [ "$(curl -s https://samhstn.github.io/markdowntables/version)" = "$(git rev-parse HEAD)" ];do
  printf "."
  sleep 5
done
```
