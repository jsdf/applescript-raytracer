#!/usr/bin/osascript

on makeColor(r, g, b)
	{red: r, green: g, blue: b}
end

on printRGB(r, g, b)
	set colr to (round (256 * r) rounding down)
	set colg to (round (256 * g) rounding down)
	set colb to (round (256 * b) rounding down)
	log ("" & colr & " " & colg & " " & colb & "\n")
end

on printColor(color)
	set colr to (round (256 * (red in color)) rounding down)
	set colg to (round (256 * (green in color)) rounding down)
	set colb to (round (256 * (blue in color)) rounding down)
	log ("" & colr & " " & colg & " " & colb & "\n")
end

on writeColor(outfile, color)
	set colr to (round (256 * (red in color)) rounding down)
	set colg to (round (256 * (green in color)) rounding down)
	set colb to (round (256 * (blue in color)) rounding down)
	write ("" & colr & " " & colg & " " & colb & "\n") to outfile
end
on writeColorInl(outfile, color)
	-- slower than writeColor
	write (round (256 * (red in color)) rounding down) to outfile
	write " " to outfile
	write (round (256 * (green in color)) rounding down) to outfile
	write " " to outfile
	write (round (256 * (blue in color)) rounding down) to outfile
	write "\n" to outfile
end
on writeRGB(outfile, r,g,b)
	set colr to (round (256 * (r)) rounding down)
	set colg to (round (256 * (g)) rounding down)
	set colb to (round (256 * (b)) rounding down)
	write ("" & colr & " " & colg & " " & colb & "\n") to outfile
end

on writePPMHeader(outfile,imageHeight,imageWidth)
	write "P3
" & imageWidth & " " & imageHeight & "
255
" to outfile
end

global outputList 
global outputListRef 

set outputList to {}  
set outputListRef to a reference to outputList

on writePPMTestImage(filename)
	set imageHeight to 256
	set imageWidth to 256

	log "building outputList"
	set imgrow to imageHeight - 1
	repeat while imgrow >= 0
		log "rendering row " & imgrow

		set imgcol to 0
		repeat with imgcol from 0 to imageWidth-1
			set r to imgcol / (imageWidth-1)
			set g to imgrow / (imageHeight-1)
			set b to 0.25
	
			set end of outputListRef to makeColor(r, g, b) 
		end
		set imgrow to imgrow - 1 -- decr loop var
	end

	log "writing output"
	set outfile to open for access filename with write permission
	writePPMHeader(outfile,imageHeight,imageWidth)
 

	set outputItems to count outputListRef
	repeat with outputIndex from 1 to outputItems
		if outputIndex mod 1000 = 0
			-- show progress
			log "wrote " & (round (outputIndex/outputItems)*100) & "%"
		end
		writeColor(outfile, (item outputIndex of outputListRef))
	end
	log "done writing output"
	
end writePPMTestImage

on sqrt(x)
	x ^ 0.5
end

on abs(x)
	if x > 0
		x
	else
		-x
	end
end

on v3(x as real, y as real, z as real)
	{x:x,y:y,z:z}
end

on v3add(self, other) 
	{ ¬
		x: x of self + x of other, ¬
		y: y of self + y of other, ¬
		z: z of self + z of other ¬
	}
end

on v3addMut(self, other) 
	set x of self to x of self + x of other
	set y of self to y of self + y of other
	set z of self to z of self + z of other
	self
end

on v3addScalar(self, scalar) 
	{ ¬
		x: x of self + scalar, ¬
		y: y of self + scalar, ¬
		z: z of self + scalar ¬
	}
end

on v3sub(self, other) 
	{ ¬
		x: x of self - x of other, ¬
		y: y of self - y of other, ¬
		z: z of self - z of other ¬
	}
end

on v3subScalar(self, scalar) 
	{ ¬
		x: x of self - scalar, ¬
		y: y of self - scalar, ¬
		z: z of self - scalar ¬
	}
end


on v3mul(self, other) 
	{ ¬
		x: x of self * x of other, ¬
		y: y of self * y of other, ¬
		z: z of self * z of other ¬
	}
end

on v3mulScalar(self, scalar) 
	{ ¬
		x: x of self * scalar, ¬
		y: y of self * scalar, ¬
		z: z of self * scalar ¬
	}
end

on v3div(self, other) 
	{ ¬
		x: x of self / x of other, ¬
		y: y of self / y of other, ¬
		z: z of self / z of other ¬
	}
end

on v3divScalar(self, scalar) 
	{ ¬
		x: x of self / scalar, ¬
		y: y of self / scalar, ¬
		z: z of self / scalar ¬
	}
end

on v3lengthSq(self)
	(x of self * x of self) + (y of self * y of self) + (z of self * z of self)
end

on v3length(self)
	v3lengthSq(self) ^ 0.5 -- x ^ 0.5 calculates sqrt(x)
end

on v3unit(v)
	v3divScalar(v, v3length(v))
end

on v3dot(u, v)
	(x of u) * (x of v) + (y of u) * (y of v) + (z of u) * (z of v)
end


on v3cross(self, other)
  set res to v3(0,0,0)
  set x of res to y of self * z of other - z of self * y of other
  set y of res to z of self * x of other - x of self * z of other
  set z of res to x of self * y of other - y of self * x of other
  res
end


on v3origin()
	v3(0,0,0)
end

on v3clone(other)
	v3(x of other, y of other, z of other)
end

on v3isEmpty(self)
	x of self = 0 and y of self = 0 and z of self = 0
end

on v3print(self)
	log ("" & x in self & " " & y in self & " " & z in self)
end

on v3copyFrom(self, other)
	set x of self to x of other
	set y of self to y of other
	set z of self to z of other
end

on v3randomInRange(min, max)
	set rng to max - min
	return v3(random number * rng + min, random number * rng + min, random number * rng + min)
end

on min(a, b)
	if a < b
		a
	else
		b
	end
end

on max(a, b)
	if a > b
		a
	else
		b
	end
end

on v3nearZero(self)
	-- Return true if the vector is close to zero in all dimensions.
	set s to 1e-8
	return (abs(x of self) < s) or (abs(y of self) < s) or (abs(z of self) < s)
end

on randomInUnitSphere()
	repeat
		set p to v3randomInRange(-1,1)
		if v3lengthSq(p) < 1
			return p
		end
	end
end

on randomUnitVector()
	v3unit(randomInUnitSphere())
end

on randomInHemisphere(normal)
	set inUnitSphere to randomInUnitSphere()
	if (v3dot(inUnitSphere, normal) > 0.0) -- In the same hemisphere as the normal
		return inUnitSphere
	else
		return v3mulScalar(inUnitSphere, -1.0)
	end
end

on clamp(x, min, max)
	if (x < min)
		return min
	end
	if (x > max)
		return max
	end
	return x
end

on makeRay(origin, direction)
	{origin:origin, direction:direction}
end

on rayAt(r, t)
	v3add((origin of r), v3mulScalar((direction of r), t))
end

on v3ToColor(v)
	makeColor(x of v, y of v, z of v)
end

on correctColor(c)
	-- sqrt for gamma correction
	set red of c to clamp(sqrt(red of c), 0.0, 0.999)
	set green of c to clamp(sqrt(green of c), 0.0, 0.999)
	set blue of c to clamp(sqrt(blue of c), 0.0, 0.999)
	c
end

on makeHitRecord()
	{t: 0, p: v3origin(), normal: v3origin(), frontFace: true, material: null}
end

on hitRecordCopyFrom(self, other)
	set t of self to t of other
	v3copyFrom(p of self, p of other)
	v3copyFrom(normal of self, normal of other)
	set frontFace of self to frontFace of other
	set material of self to material of other
	self
end

on hitRecordSetFaceNormal(self, r, outwardNormal)
	set frontFace of self to v3dot((direction of r), outwardNormal) < 0
	if frontFace of self
		set normal of self to outwardNormal
	else
		set normal of self to -outwardNormal
	end
	self
end

script spherePrototype
	-- property sphereCenter : v3
	-- property sphereRadius : number
	-- property material : material

	on hit(r,tMin,tMax,rec)
		set oc to v3sub((origin of r), my sphereCenter)
		set a to v3lengthSq(direction of r)
		set halfB to v3dot(oc, (direction of r))
		set c to v3lengthSq(oc) - my sphereRadius*my sphereRadius
		set discriminant to halfB*halfB - a*c
		
		if (discriminant < 0)
			return false
		end if

		set sqrtd to sqrt(discriminant)

		-- Find the nearest root that lies in the acceptable range.
		set root to (-halfB - sqrtd) / a
		if (root < tMin or tMax < root)
			root = (-halfB + sqrtd) / a
			if (root < tMin or tMax < root)
				return false
			end if
		end if

		set t of rec to root
		set p of rec to rayAt(r, t of rec)
		set normal of rec to v3divScalar(v3sub(p of rec, my sphereCenter), my sphereRadius)

		set outwardNormal to v3divScalar(v3sub(p of rec, my sphereCenter), my sphereRadius)
		hitRecordSetFaceNormal(rec, r, outwardNormal)
		set material of rec to my material
		return true
	end hit
end script

on newSphere(_sphereCenter, _sphereRadius, _material)
	script sphere
		property parent: spherePrototype
		property sphereCenter: _sphereCenter
		property sphereRadius: _sphereRadius
		property material: _material
	end
	return sphere
end

script hittableListPrototype
	-- property objects : {}

	on clear() 
		set my objects to {}
	end

	on add(object) 
		set end of my objects to object
	end

	on hit(r, tMin, tMax, rec)
		set tempRec to makeHitRecord()
		set hitAnything to false
		set closestSoFar to tMax

		repeat with object in my objects
			if object's hit(r, tMin, closestSoFar, tempRec)
				set hitAnything to true
				set closestSoFar to t of tempRec
				hitRecordCopyFrom(rec, tempRec)
			end
		end

		return hitAnything
	end hit
end

on newHittableList(_objects)
	script hittableList
		property parent: hittableListPrototype
		property objects: _objects
	end
	return hittableList
end


on reflect(v, n)
	return v3sub(v, v3mulScalar(n, 2*v3dot(v, n)))
end

on refract(uv, n, etaiOverEtat)
	set cosTheta to min(v3dot(v3mulScalar(uv, -1), n), 1.0)
	set rOutPerp to v3mulScalar(v3add(uv, v3mulScalar(n, cosTheta)), etaiOverEtat)
	set rOutParallel to v3mulScalar(n, -1*sqrt(abs(1.0 - v3lengthSq(rOutPerp))))
	return v3add(rOutPerp, rOutParallel)
end

on reflectance(cosine, refIdx)
	-- Use Schlick's approximation for reflectance.
	set r0 to (1-refIdx) / (1+refIdx)
	set r0 to r0*r0
	return r0 + (1-r0) * ((1 - cosine)^5)
end

on newLambertian(_albedo)
	script lambertian
		property albedo: _albedo
		on scatter(rIn, rec) 
			set scatterDirection to v3add(normal of rec, randomUnitVector())
			-- Catch degenerate scatter direction
			if v3nearZero(scatterDirection)
				set scatterDirection to normal of rec
			end
			{ ¬
				scattered: makeRay(p of rec, scatterDirection), ¬
				attenuation: v3clone(my albedo), ¬
				success: true ¬
			}
		end
	end
	return lambertian
end

on newMetal(_albedo, _fuzz)
	script metal
		property albedo: _albedo
		property fuzz: clamp(_fuzz, 0, 1)
		on scatter(rIn, rec)
			set reflected to reflect(v3unit(direction of rIn), normal of rec)
			local fuzzDirection
			if my fuzz > 1
				set fuzzDirection to v3mulScalar(randomInUnitSphere(), my fuzz)
			else
				set fuzzDirection to v3origin()
			end
			set scattered to makeRay(p of rec, v3add(reflected, fuzzDirection))
			set success to v3dot(direction of scattered, normal of rec) > 0
			{ ¬
				scattered: scattered, ¬
				attenuation: v3clone(my albedo), ¬
				success: success ¬
			}
		end
	end
	return metal
end

on newDielectric(_indexOfRefraction)
	script dielectric
		property indexOfRefraction: _indexOfRefraction
		on scatter(rIn, rec)
			if frontFace of rec
				set refractionRatio to (1.0/(my indexOfRefraction))
			else
				set refractionRatio to my indexOfRefraction
			end

			set unitDirection to v3unit(direction of rIn)

			set cosTheta to min(v3dot(v3mulScalar(unitDirection, -1), normal of rec), 1.0)
			set sinTheta to sqrt(1.0 - cosTheta*cosTheta)

			set cannotRefract to refractionRatio * sinTheta > 1.0

			local direction
			if cannotRefract or reflectance(cosTheta, refractionRatio) > random number
					set direction to reflect(unitDirection, normal of rec)
			else
					set direction to refract(unitDirection, normal of rec, refractionRatio)
			end

			set scattered to makeRay(p of rec, direction)

			{ ¬
				scattered: scattered, ¬
				attenuation: v3(1.0, 1.0, 1.0), ¬
				success: true ¬
			}
		end
	end
	return dielectric
end

on newCamera(lookfrom, lookat, vup, aspectRatio)
	set _viewportHeight to 2.0
	set _viewportWidth to aspectRatio * _viewportHeight
	set _focalLength to 1.0


  set w to v3unit(v3sub(lookfrom, lookat))
  set u to v3unit(v3cross(vup, w))
  set v to v3cross(w, u)

	set _origin to v3clone(lookfrom)
	set _horizontal to v3mulScalar(u, _viewportWidth)
	set _vertical to v3mulScalar(v, _viewportHeight)
 
	-- lowerLeftCorner = origin - horizontal/2 - vertical/2 - w
	set _lowerLeftCorner to ¬
		v3sub( ¬
			v3sub( ¬
				v3sub(_origin, v3divScalar(_horizontal, 2)), ¬
				v3divScalar(_vertical, 2) ¬
			), ¬
			w ¬
		)

	script camera
		property viewportHeight : _viewportHeight
		property viewportWidth : _viewportWidth
		property focalLength : _focalLength

		property origin : _origin
		property horizontal : _horizontal
		property vertical : _vertical

		-- lowerLeftCorner = origin - horizontal/2 - vertical/2 - v3(0, 0, focalLength)
		property lowerLeftCorner:  _lowerLeftCorner

		on getRay(s, t)
			-- ray(origin, lower_left_corner + s*horizontal + t*vertical - origin);
			makeRay(my origin, v3sub(v3add(v3add(my lowerLeftCorner, v3mulScalar(my horizontal, s)), v3mulScalar(my vertical, t)), my origin))
		end
	end
end

on rayColor(r, world, depth)
	set rec to makeHitRecord()
	set nearInfinity to 2.0e20
	set nearZero to 0.001

	-- If we've exceeded the ray bounce limit, no more light is gathered.
	if depth <= 0
		return v3origin()
	end

	set didHit to world's hit(r, nearZero, nearInfinity, rec)
	if didHit
		set rand to randomInHemisphere(normal of rec)
		set target to v3add(p of rec, rand)
		set dir to v3sub(target, p of rec)
		set material to material of rec
		if material = null
			log "no material on"
			log rec
		end

		-- bounce light
		set scatterResult to material's scatter(r, rec)
		if (success of scatterResult)
			return v3mul(attenuation of scatterResult, rayColor(scattered of scatterResult, world, depth-1))
		end
		return v3(0,0,0)

		-- simple bounce light
		-- return v3mulScalar(rayColor(makeRay(p of rec, dir), world, depth-1), 0.5)

		-- color based on normal
		-- return v3mulScalar(v3add(normal of rec, v3(1,1,1)), 0.5)
	end

	set t to 0.5*(y of v3unit(direction of r) + 1.0)
	return v3add(v3mulScalar(v3(1.0, 1.0, 1.0),(1.0-t)), v3mulScalar(v3(0.5, 0.7, 1.0),t))
end

on writeRaytracedImage(filename, imageWidth, samplesPerPixel, maxDepth)
	-- image
	set aspectRatio to 16.0 / 9.0
	set imageHeight to round (imageWidth / aspectRatio) rounding down

	-- world
	set materialGround to newLambertian(v3(0.5, 0.5, 0.5))
	set materialBlue to newLambertian(v3(0.1, 0.2, 0.5))
	-- set materialLeft   to newMetal(v3(0.8, 0.8, 0.8), 1)
	set materialMetal  to newMetal(v3(0.8, 0.6, 0.2), 1)
	set materialGlass to newDielectric(1.5)
	set world to newHittableList({})
	world's add(newSphere(v3( 0.0, -100.5, -1.0), 100.0, materialGround)) -- ground
	world's add(newSphere(v3( 0.0,    0.0, -1.0),   0.5, materialBlue)) -- center
	world's add(newSphere(v3(-1.0,    0.0, -1.0),   0.5, materialGlass)) -- left
	world's add(newSphere(v3( 1.0,    0.0, -1.0),   0.5, materialMetal)) -- right

	-- camera
	-- newCamera(lookfrom, lookat, vup, aspectRatio)
	set cam to newCamera(v3(-2,2,1), v3(0,0,-1), v3(0,1,0), aspectRatio)

	log "begin raytracing"
	set raytracingStartTime to current date

	set imgrow to imageHeight - 1 -- j
	repeat while imgrow >= 0
		set scanlineStartTime to current date

		set imgcol to 0 -- i
		repeat with imgcol from 0 to imageWidth-1
			set pixelColor to v3origin()
			repeat with sample from 0 to samplesPerPixel
				set u to (imgcol + random number) / (imageWidth-1)
				set v to (imgrow + random number) / (imageHeight-1)
				set r to cam's getRay(u, v)
				v3addMut(pixelColor, rayColor(r, world, maxDepth))
			end repeat
			set end of outputListRef to correctColor(v3ToColor(v3divScalar(pixelColor, samplesPerPixel)))
		end
		log "rendered scanline " & imgrow & " in " & (current date) - scanlineStartTime & "s"

		set imgrow to imgrow - 1 -- decr loop var
	end

	log "raytracing took " & (current date) - raytracingStartTime & "s"

	set outfile to open for access filename with write permission
	writePPMHeader(outfile,imageHeight,imageWidth)

	log "writing output"

	set outputItems to count outputListRef
	repeat with outputIndex from 1 to outputItems
		if outputIndex mod 1000 = 0
			-- show progress
			log "wrote " & (round (outputIndex/outputItems)*100) & "%"
		end
		writeColor(outfile, (item outputIndex of outputListRef))
	end
	log "done writing output"
	
end writeRaytracedImage

set everythingStartTime to current date

-- writePPMTestImage("test.ppm")
-- writeRaytracedImage(filename, imageWidth, samplesPerPixel, maxDepth)
-- writeRaytracedImage("image.ppm", 400, 100, 50) -- high quality
writeRaytracedImage("image.ppm", 200, 1, 10)
-- writeRaytracedImage("image.ppm", 100, 4, 10)

log "done in " & (current date) - everythingStartTime & "s"
 
-- don't print result
""