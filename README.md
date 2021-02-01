# applescript-raytracer

an implementation of [raytracing in one weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html) in applescript

example render:

![rendered output of raytracer](render.jpg)

this render took about 1 hour parallelized across 8 cpu cores

to run it yourself:

```sh
./raytracer.applescript
```

this will output a [ppm image file](https://en.wikipedia.org/wiki/Netpbm#PPM_example) named `output_[timestamp].ppm`

to spawn multiple worker processes, to take advantage of multiple cpu cores, run the script with the `smp` argument. no logging of incremental progress will be shown in this mode


```sh
./raytracer.applescript smp
```

you can edit `renderConfig` property [defined at the top of raytracer.applescript](raytracer.applescript#L7) to adjust the resolution, rays per pixel, and max bounces per ray, which will substantially affect the time taken to render.

you can also change the `randomSeed` property to generate a different random layout of the smaller spheres

with a few small changes the code also [runs on classic mac os](https://twitter.com/ur_friend_james/status/1353168983122464769)
