# Interview Questions Of The Week

From the _[rendezvous with cassidoo](https://cassidoo.co/newsletter/)_, a weekly tech newsletter by Cassidy Williams.

> [!NOTE]
>
> - Answers under section _Original answers_ are provided by [me](https://github.com/izkreny/).
> - All other ones from various people (mostly from the [Ruby Users Forum](https://www.rubyforum.org/)) are credited by prefixing method names with usernames or social handles, and with the link(s) to the web source.
> - Answers are tested against the latest stable version of
> [Ruby](https://www.ruby-lang.org/en/) programming language.
> - Source code for this website: https://github.com/izkreny/cassidoo_QOTW

> [!TIP]
>
> - Maximum line lenght for *oneline* solution **MUST** not exceed **150** (columns).
> - *Oneline* solution **MIGHT** use abbreviated variable names.
> - Additional *multiline* solution **SHOULD** be provided if *one-liner* is too cryptic!

> [!IMPORTANT]
>
> - Unless otherwise noted, all _Original answers_ are the result of my own mental capabilities and typed with my bare hands, with no AI interference whatsoever. 🖖

> [!WARNING]
>
> - Ruby `Module` class is excessively used for namespace purposes in not so recommended/standard way---they are in plural noun form and not in singular noun or adjective form. This is not how you SHOULD usually use them, but it is impeccably good enough for this little project, especially because it avoids clashing with the standard Ruby [Benchmark](https://github.com/ruby/benchmark) module.

> [!CAUTION]
>
> - In some Questions metaprogramming is used inside `Minitest::Test` subclasses because it makes a perfect fit for the nature of this project (i.e. to easily test all provided Answers); but this is undoubtedly something that is NOT recommended (or even FORBIDDEN!) in general testing practice, JFTR! 👺
