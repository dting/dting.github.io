---
layout: page
permalink: /project-euler/
title: Project Euler
tags: [euler, spoiler]
---

Here are my notes on solving some project euler problems. Contains spoilers!

## Solved

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
