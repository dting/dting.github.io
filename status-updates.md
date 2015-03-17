---
layout: page
permalink: /status-updates/
title: "Status Updates Archive"
description:
modified: 2014-08-12 22:26:24 +0600
---
<ul class="post-list">
{% for status in site.data.statuses reversed %}
<li>
{{ status.message }}<span class="entry-date"><time datetime="{{ status.date }}" itemprop="datePublished">{{ status.date | date: "%b %d, %Y" }}</time>
</li>
{% endfor %}
</ul>
