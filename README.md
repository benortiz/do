# do - cli activity log

## Contents

- [What](#what)
- [Why](#why)
- [Installation](#installation)
- [The "do" file](#the-do-file)
- [Configuration](#configuration)
- [Usage](#usage)

## What

`do` is a basic CLI for adding and listing "what was I doing" reminders in a [TaskPaper-formatted](http://www.hogbaysoftware.com/products/taskpaper) text file. It allows for multiple sections/categories and flexible output formatting.

## Why
Talk about usecases.

## Installation

```bash
$ gem install do
```

Run `do config` to open your `~/.dorc` file in the editor defined in the $EDITOR environment variable. Set up your `do_file` right away (where you want entries to be stored), and cover the rest after you've read the docs.

## The "do" file

The file that stores all of your entries is generated the first time you add an entry with `do now` (or `do later`). By default the file is created in "~/.do.md", but this can be modified in the config file.

The format of the "do" file is TaskPaper-compatible. You can edit it by hand at any time (in TaskPaper or any text editor), but it uses a specific format for parsing, so be sure to maintain the dates and pipe characters. 

Notes are anything in the list without a leading hyphen and date. They belong to the entry directly before them, and they should be indented one level beyond the parent item. When using the `now` and `later` commands on the command line, you can start the entry with a quote and hit return, then type the note and close the quote. Anything after the first line will be turned into a TaskPaper-compatible note for the task.

## Configuration

A basic configuration looks like this:

```yaml
---
do_file: ~/.do.md
current_section: Currently
default_date_format: '%Y-%m-%d %H:%M'
```

The config file is stored in `~/.dorc`, and is created on the first run.

### Per-folder configuration

Any options found in a `.dorc` anywhere in the hierarchy between your current folder and your home folder will be appended to the base configuration, overriding or extending existing options. This allows you to put a `.dorc` file into the base of a project and add specific configurations (such as default tags) when working in that project on the command line.

Any part of the configuration can be copied into these local files and modified. You only need to include the parts you want to change or add.

### do file location

The one thing you'll probably want to adjust is the file that the notes are stored in. That's the `do_file` key:

```yaml
do_file: ~/.do.md
```

### "Current actions" section

You can rename the section that holds your current tasks. By default, this is "Currently," but if you have some other bright idea, feel free:

```yaml
current_section: Currently
```

### Default editors

In the case of the `do now -e` command, your $EDITOR environment variable will be used to complete the entry text and notes. Set it in your `~/.bash_profile` or whatever is appropriate for your system:

```bash
export EDITOR="mate -w"
```

## Usage

```bash
do [global options] command [command options] [arguments...]
```

### Global options:

    --version           - Display the program version
    --help              - Show help message and usage summary

### Commands:

    help           - Shows a list of commands and global options
    help [command] - Shows help for any command (`do help now`)

#### Adding entries:

    now      - Add an entry
    later    - Add an item to the Later section
    done     - Add a completed item with @done(date). No argument finishes last entry.
    meanwhile - Finish any @meanwhile tasks and optionally create a new one

The `do now` command can accept `-s section_name` to send the new entry straight to a non-default section. It also accepts `--back AMOUNT` to let you specify a start date in the past using "natural language." For example, `do now --back 25m ENTRY` or `do now --back "yesterday 3:30pm" ENTRY`.

You can finish the last unfinished task when starting a new one using `do now` with the `-f` switch. It will look for the last task not marked `@done` and add the `@done` tag with the start time of the new task (either the current time or what you specified with `--back`).

`do done` is used to add an entry that you've already completed. Like `now`, you can specify a section with `-s section_name`. You can also skip straight to Archive with `-a`.

`do done` can also backdate entries using natural language with `--back 15m` or `--back "3/15 3pm"`. That will modify the starting timestamp of the entry. You can also use `--took 1h20m` or `--took 1:20` to set the finish date based on a "natural language" time interval. If `--took` is used without `--back`, then the start date is adjusted (`--took` interval is subtracted) so that the completion date is the current time.

When used with `do done`, `--back` and `--took` allow time intervals to be accurately counted when entering items after the fact. `--took` is also available for the `do finish` command, but cannot be used in conjunction with `--back`. (In `finish` they both set the end date, and neither has priority. `--back` allows specific days/times, `--took` uses time intervals.)

All of these commands accept a `-e` argument. This opens your command line editor as defined in the environment variable `$EDITOR`. Add your entry, save the temp file and close it, and the new entry will be added. Anything after the first line is included as a note on the entry.

`do meanwhile` is a special command for creating and finishing tasks that may have other entries come before they're complete. When you create an entry with `do meanwhile [entry text]`, it will automatically complete the last @meanwhile item (dated @done tag) and add the @meanwhile tag to the new item. This allows time tracking on a more general basis, and still lets you keep track of the smaller things you do while working on an overarching project. The `meanwhile` command accepts `--back [time]` and will backdate the @done tag and start date of the new task at the same time. Running `meanwhile` with no arguments will simply complete the last @meanwhile task. See `do help meanwhile` for more options.

#### Modifying entries:

    finish      - Mark last X entries as @done
    tag         - Tag last entry
    note        - Add a note to the last entry

##### Finishing

`do finish` by itself is the same as `do done` by itself. It adds `@done(timestamp)` to the last entry. It also accepts a numeric argument to complete X number of tasks back in history. Add `-a` to also archive the affected entries.

`do finish` also provides an `--auto` flag, which you can use to set the end time of any entry to 1 minute before the start time of the next. Running a command such as `do finish --auto 10` will go through the last 10 entries and sequentially update any without a `@done` tag with one set to the time just before the next entry in the list.

As mentioned above, `finish` also accepts `--back "2 hours"` (sets the finish date from time now minus interval) or `--took 30m` (sets the finish date to time started plus interval) so you can accurately add times to completed tasks, even if you don't do it in the moment.


##### Tagging and Autotagging

`tag` adds one or more tags to the last entry, or specify a count with `-c X`. Tags are specified as basic arguments, separated by spaces. For example:

```bash
do tag -c 3 client cancelled
```

... will mark the last three entries as "@client @cancelled." Add `-r` as a switch to remove the listed tags instead.

You can optionally define keywords for common tasks and projects in your `.dorc` file. When these keywords appear in an item title, they'll automatically be converted into @tags. The "whitelist" tags are exact (but case insensitive) matches. You can also define "synonyms" which will add a tag at the end based on keywords associated with it. When defining synonym keys, be sure to indent but _not_ hyphenate the keys themselves, while hyphenating the list of synonyms at the same indent level as their key. See "playing" and "writing" in the list below for illustration. Follow standard yaml syntax.

To add autotagging, include a section like this in your `~/.dorc` file:

```yaml
autotag:
  whitelist:
  - do
  - mindmeister
  - marked
  - playing
  - working
  - writing
  synonyms:
    playing:
    - hacking
    - tweaking
    - toying
    - messing
    writing:
    - blogging
    - posting
    - publishing
```

##### Note

`note` lets you append a note to the last entry. You can specify a section to grab the last entry from with `-s section_name`. `-e` will open your $EDITOR for typing the note, but you can also just include it on the command line after any flags. You can also pipe a note in on STDIN (`echo "fun stuff"|do note`). If you don't use the `-r` switch, new notes will be appended to the existing notes, and using the `-e` switch will let you edit and add to an existing note. The `-r` switch will remove/replace a note; if there's new note text passed when using the `-r` switch, it will replace any existing note. If the `-r` switch is used alone, any existing note will be removed.

You can also add notes at the time of entry by using the `-n` or `--note` flag with `do now`, `do later`, or `do done`. If you pass text to any of the creation commands which has multiple lines, everything after the first line break will become the note.

#### Displaying entries:

    show      - List all entries
    recent    - List recent entries
    today     - List entries from today
    yesterday - List entries from yesterday
    last      - Show the last entry
    grep      - Show entries matching text or pattern

`do show` on its own will list all entries in the "Currently" section. Add a section name as an argument to display that section instead. Use "all" to display all entries from all sections.

You can filter the `show` command by tags. Simply list them after the section name (or "all"). The boolean defaults to "ANY," meaning any entry that contains any of the listed tags will be shown. You can use `-b ALL` or `-b NONE` to change the filtering behavior: `do show all done cancelled -b NONE` will show all tasks from all sections that do not have either "@done" or "@cancelled" tags.

Use `-c X` to limit the displayed results. Combine it with `-a newest` or `-a oldest` to choose which chronological end it trims from. You can also set the sort order of the output with `-s asc` or `-s desc`.

The `show` command can also show the time spent on a task if it has a `@done(date)` tag with the `-t` option. This requires that you include a `%interval` token in template -> default in the config. You can also include `@start(date)` tags, which override the timestamp when calculating the intervals.

If you have a use for it, you can use `-o csv` on the show or view commands to output the results as a comma-separated CSV to STDOUT. Redirect to a file to save it: `do show all done -o csv > ~/Desktop/done.csv`. You can do the same with `-o json`.

`do yesterday` is great for stand-ups, thanks to [Sean Collins](https://github.com/sc68cal) for that. Note that you can show yesterday's activity from an alternate section by using the section name as an argument (e.g. `do yesterday archive`).

`do on` allows for full date ranges and filtering. `do on saturday`, or `do on one month to today` will give you ranges. You can use the same terms with the `show` command by adding the `-f` or `--from` flag. `do show @done --from "monday to friday"` will give you all of your completed items for the last week (assuming it's the weekend).

#### Sections

    sections    - List sections
    choose      - Select a section to display from a menu
    add_section - Add a new section to the "do" file

#### Utilities

    archive  - Move entries between sections
    open     - Open the "do" file in an editor (OS X)
    config   - Edit the default configuration

#### Archiving

    COMMAND OPTIONS
        -k, --keep=arg - Count to keep (ignored if archiving by tag) (default: 5)
        -t, --to=arg   - Move entries to (default: Archive)
        -b, --bool=arg - Tag boolean (default: AND)

The `archive` command will move entries from one section (default: Currently) to another section (default: Archive). 

`do archive` on its own will move all but the most recent 5 entries from currently into the archive.

`do archive other_section` will archive from "other_section" to Archive.

`do archive other_section -t alternate` will move from "other_section" to "alternate." You can use the `-k` flag on any of these to change the number of items to leave behind. To move everything, use `-k 0`.

You can also use tags to archive. You define the section first, and anything following it is treated as tags. If your first argument starts with "@", it will assume all sections and assume any following arguments are tags.

By default tag archiving uses an "AND" boolean, meaning all the tags listed must exist on the entry for it to be moved. You can change this behavior with `-b OR` or `-b NONE` ("ALL" and "ANY" also work). 

Example: Archive all Currently items for @client that are marked @done

```bash
do archive @client @done
```
