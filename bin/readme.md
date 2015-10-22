## Kindle

### fb2 -> azw3

```
parallel --plus -t  'ebook-convert {} {..}.azw3 && rm {}'  ::: *.fb2.zip

for d in * ; do cd "$d" ; parallel --plus -t  'ebook-convert {} {..}.azw3 && rm {}'  ::: *.fb2.zip ; cd .. ; done
```
