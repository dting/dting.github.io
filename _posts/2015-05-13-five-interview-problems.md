---
layout: post
title: Solutions to the SVpino programming problems 
categories: coding
tags:
  - interview
  - puzzles
imagefeature: interview-problems.jpg
covereffect: slice
imagecredit: <a xmlns:cc='http://creativecommons.org/ns#' rel='cc:attributionURL' property='cc:attributionName' href='https://www.flickr.com/people/124329303@N08/' target='_blank'>dting44</a>
imagelicense: <a rel='license' href='http://creativecommons.org/licenses/by/2.0/' target='_blank'><img src='http://i.creativecommons.org/l/by/2.0/80x15.png' alt='Creative Commons Creative Commons Attribution 2.0 Generic License' title='Creative Commons Creative Commons Attribution 2.0 Generic License' border='0'></a>
comments: true
mathjax: true
featured: true
published: true
---

> Five programming problems every Software Engineer should be able to solve in less than 1 hour
> <small><cite>[blog.svpino.com](https://blog.svpino.com/2015/05/07/five-programming-problems-every-software-engineer-should-be-able-to-solve-in-less-than-1-hour)</cite></small>

## Problem 1

##### Write three functions that compute the sum of the numbers in a given list using a for-loop, a while-loop, and recursion.

{% highlight Python %}
def sum_for_loop(arr):
  s = 0
  for a in arr:
    s += a
  return s

def sum_while_loop(arr):
  s = 0
  n = 0
  while n < len(arr):
    s += arr[n]
    n += 1
  return s
  
def sum_recursive(arr):
  if arr:
    return arr[0] + sum_recursive(arr[1:])
  return 0
{% endhighlight %}

This one is pretty straight forward but awkward in Python.

## Problem 2
     
##### Write a function that combines two lists by alternatingly taking elements. For example: given the two lists [a, b, c] and [1, 2, 3], the function should return [a, 1, b, 2, c, 3].

Probably need to ask some questions about the desired results before starting on this problem. Clarify how to handle lists of unequal sizes. I made the assumption that unmatched elements should be appended.

{% highlight Python %}
def combine_lists_loop(a, b):
  limit = max(len(a), len(b))
  arr = []
  for i in range(limit):
    if i < len(a):
      arr.append(a[i])
    if i < len(b):
      arr.append(b[i])
  return arr
  
def combine_lists_comprehension(a, b):
  # return [v for p in itertools.izip_longest(a, b) for v in p if v]
  return [v for p in map(None, a, b) for v in p if v]
{% endhighlight %}

The list comprehension solution is somewhat interesting. In order the pad the shorter list with none, we use `map(None, a, b)`.

From the Python docs for [`map`](https://docs.python.org/2/library/functions.html#map):

"If one iterable is shorter than another it is assumed to be extended with None items. If function is None, the identity function is assumed; if there are multiple arguments, map() returns a list consisting of tuples containing the corresponding items from all iterables (a kind of transpose operation)." 

[`itertools.izip_longest`](https://docs.python.org/2/library/itertools.html#itertools.izip_longest) would be another option. Its not surprising that the [itertools recipes](https://docs.python.org/2/library/itertools.html#recipes) has a function:

{% highlight Python %}
def roundrobin(*iterables):
    "roundrobin('ABC', 'D', 'EF') --> A D E B F C"
    # Recipe credited to George Sakkis
    pending = len(iterables)
    nexts = cycle(iter(it).next for it in iterables)
    while pending:
        try:
            for next in nexts:
                yield next()
        except StopIteration:
            pending -= 1
            nexts = cycle(islice(nexts, pending))
{% endhighlight %}

## Problem 3

##### Write a function that computes the list of the first 100 Fibonacci numbers. By definition, the first two numbers in the Fibonacci sequence are 0 and 1, and each subsequent number is the sum of the previous two. As an example, here are the first 10 Fibonnaci numbers: 0, 1, 1, 2, 3, 5, 8, 13, 21, and 34.

{% highlight Python %}
def fib_first_hundred():
  f = [0,1]
  while len(f) < 100:
    f.append(f[-1] + f[-2])
  return f
{% endhighlight %}

Memoization to prevent recalculating previous values and such. [`Project Euler #2`](http://localhost:4000/euler/solved/002/) *(spoilers)* deals with Fibonacci patterns.

## Problem 4

##### Write a function that given a list of non negative integers, arranges them such that they form the largest possible number. For example, given [50, 2, 1, 9], the largest formed number is 95021.

{% highlight Python %}
def largest_n_sort(a):
  limit = len(a)
  while limit:
    limit -= 1
    swapped = False
    j = 0
    while j < limit:
      lhs = str(a[j])
      rhs = str(a[j + 1])
      if lhs+rhs < rhs+lhs:
        swapped = True
        a[j], a[j + 1] = a[j + 1], a[j]
      j += 1
    if not swapped:
      break
  return a
  
def largest_n_sort(a):
  return sorted(a, key=lambda x, y: str(x)+str(y) < str(y)+str(x))
{% endhighlight %}

This is the most interesting question of the bunch. 

Initially I was thinking of using a trie then walking the trie to lexicographically sort the array. That actually give you incorrect answer in cases such as `[5, 56, 50]`. `[56, 50, 5]` would be highest lexicographic order and `[5, 50, 56]` the lowest. The correct answer is `[56, 5, 50]`. 

Lexicographic sorting is on the right track, but the trick is to compare on the *result* of the concatenations of the values in the `a+b` and `b+a` configurations.

## Problem 5

##### Write a program that outputs all possibilities to put + or - or nothing between the numbers 1, 2, ..., 9 (in this order) such that the result is always 100. For example: 1 + 2 + 34 – 5 + 67 – 8 + 9 = 100.

{% highlight Python %}
>>> from itertools import product
>>>
>>> def combine(a, b):
...   return [v for p in map(None, a, b) for v in p if v]
...
>>> for x in product(['', '+', '-'], repeat=8):
...   s = ''.join(map(str,  combine(range(1, 10), x)))
...   if eval(s) == 100:
...     print s + "=100"
...
123+45-67+8-9=100
123+4-5+67-89=100
123-45-67+89=100
123-4-5-6-7+8-9=100
12+3+4+5-6-7+89=100
12+3-4+5+67+8+9=100
12-3-4+5-6+7+89=100
1+23-4+56+7+8+9=100
1+23-4+5+6+78-9=100
1+2+34-5+67-8+9=100
1+2+3-4+5+6+78+9=100
{% endhighlight %}

We get to use problem 2 to solve this problem! I went with the brute force method. There are 8 slots for either `+`, `-`, or `nothing` in between the digits. That means there are only a total of $$3^8 = 6561$$ possibilities. 
