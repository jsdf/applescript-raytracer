#!/usr/bin/osascript

on makeColor(r, g, b)
	{red: r, green: g, blue: b}
end

on printRGB(r, g, b)
	set colr to (round (255.999 * r) rounding down)
	set colg to (round (255.999 * g) rounding down)
	set colb to (round (255.999 * b) rounding down)
	log ("" & colr & " " & colg & " " & colb & "\n")
end

on printColor(color)
	set colr to (round (255.999 * (red in color)) rounding down)
	set colg to (round (255.999 * (green in color)) rounding down)
	set colb to (round (255.999 * (blue in color)) rounding down)
	log ("" & colr & " " & colg & " " & colb & "\n")
end

on writeColor(outfile, color)
	set colr to (round (255.999 * (red in color)) rounding down)
	set colg to (round (255.999 * (green in color)) rounding down)
	set colb to (round (255.999 * (blue in color)) rounding down)
	write ("" & colr & " " & colg & " " & colb & "\n") to outfile
end
on writeColorInl(outfile, color)
	-- slower than writeColor
	write (round (255.999 * (red in color)) rounding down) to outfile
	write " " to outfile
	write (round (255.999 * (green in color)) rounding down) to outfile
	write " " to outfile
	write (round (255.999 * (blue in color)) rounding down) to outfile
	write "\n" to outfile
end
on writeRGB(outfile, r,g,b)
	set colr to (round (255.999 * (r)) rounding down)
	set colg to (round (255.999 * (g)) rounding down)
	set colb to (round (255.999 * (b)) rounding down)
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

on v3origin()
	v3(0,0,0)
end

on v3clone(other)
	v3(x of other, y of other, z of other)
end

on v3copyFrom(self, other)
	set x of self to x of other
	set y of self to y of other
	set z of self to z of other
end

on v3randomInRange(min,max)
	return v3(random number from min to max, random number from min to max, random number from min to max)
end

on randomInUnitSphere()
	repeat
		set p to v3randomInRange(-1,1)
		if v3lengthSq(p) < 1
			return p
		end
	end
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

on makeHitRecord()
	{t: 0, p: v3origin(), normal: v3origin(), frontFace: true}
end

on hitRecordCopyFrom(self, other)
	set t of self to t of other
	v3copyFrom(p of self, p of other)
	v3copyFrom(normal of self, normal of other)
	set frontFace of self to frontFace of other
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
	-- property sphereCenter : v3(0,0,0)
	-- property sphereRadius : 1

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
		return true
	end hit
end script

on newSphere(_sphereCenter, _sphereRadius)
	script sphere
		property parent: spherePrototype
		property sphereCenter: _sphereCenter
		property sphereRadius: _sphereRadius
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

on rayColor(r, world)
	set rec to makeHitRecord()
	set nearInfinity to 2.0e20
	set didHit to world's hit(r, 0, nearInfinity, rec)
	if didHit
    -- point3 target = rec.p + rec.normal + random_in_unit_sphere();

		return v3ToColor(v3mulScalar(v3add(normal of rec, v3(1,1,1)), 0.5))
	end

	set t to 0.5*(y of v3unit(direction of r) + 1.0)
	return v3ToColor(v3add(v3mulScalar(v3(1.0, 1.0, 1.0),(1.0-t)), v3mulScalar(v3(0.5, 0.7, 1.0),t)))
end

on writeRaytracedImage(filename)
	-- image
	set aspectRatio to 16.0 / 9.0
	set imageWidth to 400
	set imageHeight to round (imageWidth / aspectRatio) rounding down

	-- world
	set world to newHittableList({})
	world's add(newSphere(v3(0,0,-1), 0.5))
	world's add(newSphere(v3(0,-100.5,-1), 100))

	-- camera
	set viewportHeight to 2.0
	set viewportWidth to aspectRatio * viewportHeight
	set focalLength to 1.0

	set origin to v3(0, 0, 0)
	set horizontal to v3(viewportWidth, 0, 0)
	set vertical to v3(0, viewportHeight, 0)

	-- lowerLeftCorner = origin - horizontal/2 - vertical/2 - v3(0, 0, focalLength)
	set lowerLeftCorner to ¬
		v3sub( ¬
			v3sub( ¬
				v3sub(origin, v3divScalar(horizontal, 2)), ¬
				v3divScalar(vertical, 2) ¬
			), ¬
			v3(0, 0, focalLength) ¬
		)


	log "building outputList"
	set imgrow to imageHeight - 1 -- j
	repeat while imgrow >= 0
		log "rendering scanline " & imgrow

		set imgcol to 0 -- i
		repeat with imgcol from 0 to imageWidth-1

			set u to imgcol / (imageWidth-1)
			set v to imgrow / (imageHeight-1)
			-- r = ray(origin, lower_left_corner + u*horizontal + v*vertical - origin)
			set r to makeRay(origin, v3sub(v3add(v3add(lowerLeftCorner, v3mulScalar(horizontal,u)), v3mulScalar(vertical,v)), origin))
			set end of outputListRef to rayColor(r, world)
		end
		set imgrow to imgrow - 1 -- decr loop var
	end

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

-- writePPMTestImage("test.ppm")
writeRaytracedImage("image.ppm")

 
-- don't print result
""