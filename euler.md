---
layout: page
permalink: /project-euler/
title: Project Euler
tags: [euler, spoiler]
---

Here are my notes on solving some project euler problems. Contains **spoilers**!

## <span style="color: #5ab738;">Helper functions<span>
{% highlight Javascript %}
/**
 * Decorator function for timing one or more calls of a function.
 *
 * @param {Function} f Function to be timed and repeated.
 * @param {Number} [times=1] Number of times to call f.
 * @returns {*} result Last returned result of calling f.
 */
function timer(f, times) {
  var times = times || 1,
      t = times,
      args = [].slice.call(arguments, 2), result;
  console.time(f.name + " x " + times);
  while (t--) {
    result = f.apply(null, args);
  }
  console.timeEnd(f.name + " x " + times);
  return result;
}
{% endhighlight %}

## <span style="color: #5ab738;">Solved</span>

<ul class="post-list">
{% for post in site.euler %}
  <li><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}

{% for page in site.euler.solved %}
<ul class="post-list">
  {% assign pages_list = page[1] %}
  {% for post in pages_list %}
  {% if post.title != null %}
  {% if group == null or group == post.group %}
  <li><a href="{{ site.url }}{{ post.url }}">{{ post.title }}<span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}" itemprop="datePublished">{{ post.date | date: "%b %d, %Y" }}</time></a></li>
  {% endif %}
  {% endif %}
  {% endfor %}
  {% assign pages_list = nil %}
  {% assign group = nil %}
</ul>
{% endfor %}
