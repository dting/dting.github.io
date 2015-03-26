---
layout: post
title: Two Printers
description: "Calculating time required to finish a job."
categories: coding
tags:
  - codeabbey
  - javascript
  - algorithms
imagefeature: printers.jpg
covereffect: slice
imagecredit: <a xmlns:cc='http://creativecommons.org/ns#' rel='cc:attributionURL' property='cc:attributionName' href='https://www.flickr.com/people/calliope/' target='_blank'>Muffet</a>
imagelicense: <a rel="license" href="http://creativecommons.org/licenses/by/2.0/" target="_blank"><img src="http://i.creativecommons.org/l/by/2.0/80x15.png" alt="Creative Commons Creative Commons Attribution 2.0 Generic License" title="Creative Commons Creative Commons Attribution 2.0 Generic License" border="0"></a>
comments: true
mathjax: true
featured: false
published: true
---

> We believe that three things lead to success: <br>
> Practice, Practice and Practice! <br>
> <small><cite>Code Abbey</cite></small>

[Cody Abbey](http://www.codeabbey.com/) is a neat site with coding challenges, similar to Project Euler, but less focused on math and heavier on the gamification.

Like many sites with programming challenges, there is an inductive learning aspect to help the user succeed. The problems are listed in order of "blessing" for completion. Blessing is somewhat correlated to their difficulty.

Most of the earlier problems are pretty easy but this problem gave me more than a little trouble.

#### The Problem

[`Problem #22`](http://www.codeabbey.com/index/task_view/two-printers)

The gist of the problem is if you have two printers, $$A$$ that prints one page in $$X$$ time and $$B$$ that prints one page in $$Y$$ time, how much time does it take to print $$N$$ pages. Simple math right?

$$\begin{align*}
N & = A(t) + B(t) \\

A(t) & = \left(\frac 1X \right) t \\

B(t) & = \left(\frac 1Y \right) t \\

N & = \left(\frac 1X\right) t + \left(\frac 1Y\right) t = \left(\frac {X + Y}{XY}\right)t \\

F(t) & = \left(\frac{XY}{X+Y}\right) N
\end{align*}$$

{% highlight Javascript %}
function completionTime(X, Y, N) {
  return (X * Y * N) / (X + Y);
}
completionTime(1, 1, 5); // 2.5
completionTime(3, 5, 4); // 7.5
{% endhighlight %}


#### The Catch

The example with provided answers didn't match up with the output from the function.

{% highlight Javascript %}
input data:
2
1 1 5
3 5 4

answer:
3 9
{% endhighlight %}

The problem is pretty subtle and took more time than I'd like to admit to find. The clue lies in the fact that the answer times are whole numbers.

`completionTime(...)` returns how much time it would take if the printers could contribute partial pages. If we were solving for the amount of time two hoses could fill a bucket together our function would work. In this case, our printers work on pages independently and rather than combining pages, each printer should only contribute whole pages.

The `completionTime`, $$t$$, is still useful for finding the answer. It can be used to determine the number of pages each printer should print. At $$t$$, both printers would be working on the last page to be printed, so the answer lies in one of 2 possible scenarios:

$$\begin{align*}

\mathtt{\text{scenario 1}}:\; & A_{pages} = \lfloor A(t) \rfloor, & B_{pages} = \lceil B(t) \rceil \\
\mathtt{\text{scenario 2}}:\; & A'_{pages} = \lceil A(t) \rceil, & B'_{pages} = \lfloor B(t) \rfloor

\end{align*}$$


#### Solutions

<span style="color: red">**Spoilers Below**</span>

So the solution to the problem becomes solving for the amount of time each scenario would take (the max of either machine in that scenario), and finding the min time of the two.

$$\begin{align*}

A_{pages} & = A(t) = \left( \frac 1X \right) t \Rightarrow t = XA_{pages} \\
B_{pages} & = B(t) = \left( \frac 1Y \right) t \Rightarrow t = YB_{pages} \\
\\
t_{scenario1} & = max \left( XA_{pages} , YB_{pages} \right) \\
t_{scenario2} & = max \left( XA'_{pages} , YB'_{pages} \right) \\
\\
t_{completion} & = min \left( max \left(XA_{pages} , YB_{pages} \right) , max \left( XA'_{pages} , YB'_{pages} \right) \right)
\end{align*}$$

Written out as code we have:

{% highlight Javascript %}
function optimalCompletionTime(X, Y, N) {
  return (X * Y * N) / (X + Y);
}

function completionTime(X, Y, N) {
  var ot, An1, Bn1, An2, Bn2, t1, t2;
  ot = optimalCompletionTime(X, Y, N);
  // Scenario 1
  An1 = Math.floor(ot/X),
  Bn1 = N - An1, // N = An1 + Bn1 => Bn1 = N - An1.
  t1 = Math.max(X * An1, Y * Bn1),
  // Scenario 2
  An2 = Math.ceil(ot/X),
  if (An1 === An2) return t1; // Shortcut out if Scenario 1 and 2 are the same.
  Bn2 = N - An2, // N = An2 + Bn2 => Bn2 = N - An2.
  t2 = Math.max(X * An2, Y * Bn2);
  // Return faster of the 2 scenarios.
  return Math.min(t1, t2);
}
completionTime(1,1,5) // 3
completionTime(3,5,4) // 9

# Time O(1)
{% endhighlight %}

#### Dynamic Programming

One of the perks for solving a problem on Code Abbey is being able to see other people's solutions. I came across one that I like a lot which uses [`dynamic programming`](http://en.wikipedia.org/wiki/Dynamic_programming).

This solution is fairly easy to visualize when put in an OOP context so let's start there.

{% highlight Javascript %}
function Printer(rate) {
  var rate = rate; // Time per page.
  var pages = 0;
  // Amount of time required to print all the queued pages.
  this.finishTime = function() {
    return pages * rate;
  };
  // The time at which an additional page would finish printing.
  this.next = function() {
    return this.finishTime() + rate;
  };
  this.queuePage = function() {
    pages++;
  };
}
{% endhighlight %}

The `Printer` class is constructed with a `rate` - time to print 1 page and functions: `queuePage` - adds pages to be printed, `finishTime` - returns the time to finish queued pages, and `next` - returns the finish time if another page is queued.

With this class we can break down the problem into finding the printer that will result in the lowest finish time for each page we need to print. For the first page, we check all the values that are returned for `next()`, on that printer we queue a page by calling `queuePage()`.

When we repeat this process as many times as pages to be printed. The value returned by `next()` takes into account the pages that were queued on printers from previous iterations.

The final result is the highest `finishTime()` after all the pages have been queued. That is the printer that will finish last, giving us the total required time.

{% highlight Javascript %}
function completionTime(X, Y, N) {
  var printerX = new Printer(X), printerY = new Printer(Y), next;
  while (N--) {
    // Queue page on printer that would result in the lowest finish time.
    next = printerX.next() <= printerY.next() ? printerX : printerY;
    next.queuePage();
  }
  // After all pages are queued, return highest finish time.
  return Math.max(printerX.finishTime(), printerY.finishTime());
}
completionTime(1,1,5) // 3
completionTime(3,5,4) // 9
{% endhighlight %}

The class helped when figuring out the logic for solving the problem but it can be replaced with an array.

{% highlight Javascript %}
function completionTime(X, Y, N) {
  var times = [0, 0];
  while (N--) {
    if (times[0] + X <= times[1] + Y)
      times[0] = times[0] + X;
    else
      times[1] = times[1] + Y;
  }
  return Math.max.apply(null, times);
}
completionTime(1,1,5) // 3
completionTime(3,5,4) // 9
{% endhighlight %}

This solution can also be adapted to solve for time required when there are variable number of producers:

{% highlight Javascript %}
function zeroFilledArray(size) {
  return Array.apply(null, Array(size)).map(Number.prototype.valueOf,0);
}

function completionTime(rates, N) {
  var len = rates.length, times = zeroFilledArray(len), next;
  while (N--) {
    next = 0;
    for (var i = 1; i < len; i++) {
      next = times[i] + rates[i] <= times[next] ? i : next;
    }
    times[next] = times[next] + rates[next];
  }
  return Math.max.apply(null, times);
}
completionTime([1,1,1],7) // 3
completionTime([1,1,1],6) // 2
completionTime([1,1,1],5) // 2
completionTime([1,1,1],4) // 2
completionTime([1,1,1],3) // 1

# Time O(nk)
{% endhighlight %}

