<img src="https://github.com/hexagons/VoxelKit/blob/master/Assets/Logo/VoxelKit%20-%20Logo%20-%201024%20-%20BG.png?raw=true" width="128"/>

# VoxelKit

Volumetric realtime graphics.

Runs on [RenderKit](https://github.com/hexagons/RenderKit)


## Renders

### Sphere

~~~~swift
let sphere = SphereVOX(at: .cube(16))
~~~~

<img src="https://github.com/hexagons/VoxelKit/blob/master/Assets/Renders/voxelkit_render_sphere.jpg?raw=true" width="256"/>

### Gradient

~~~~swift
let gradient = GradientVOX(at: .cube(16))
gradient.direction = .linear(.x)
~~~~

<img src="https://github.com/hexagons/VoxelKit/blob/master/Assets/Renders/voxelkit_render_gradient.jpg?raw=true" width="256"/>

### Noise

~~~~swift
let noise = NoiseVOX(at: .cube(16))
~~~~

<img src="https://github.com/hexagons/VoxelKit/blob/master/Assets/Renders/voxelkit_render_noise.jpg?raw=true" width="256"/>

## Downsampled Sphere

~~~~swift
let sphere = SphereVOX(at: .cube(200))

let avg = AveragePIX()
avg.input = sphere

avg.pixView.frame = view.bounds
view.addSubview(avg.pixView)
~~~~

<img src="https://github.com/hexagons/VoxelKit/blob/master/Assets/Renders/voxelkit_render_flat_sphere.jpg?raw=true" width="256"/>

## Downsampled Sphere with Edge

~~~~swift
let sphere = SphereVOX(at: .cube(200))

let edge = EdgeVOX()
edge.input = sphere
edge.strength = 10

let avg = AveragePIX()
avg.input = edge

avg.pixView.frame = view.bounds
view.addSubview(avg.pixView)
~~~~

<img src="https://github.com/hexagons/VoxelKit/blob/master/Assets/Renders/voxelkit_render_flat_sphere_edge.jpg?raw=true" width="256"/>

## VOX

### VOXContent

#### VOXGenerator

- ColorVOX
- GradientVOX
- NoiseVOX
- SphereVOX

### VOXEffect

#### VOXSingleEffect

- BlurVOX
- EdgeVOX
- FeedbackVOX
- LevelsVOX
- QuantizeVOX
- ResolutionVOX
- ThresholdVOX
- TransformVOX

#### VOXMergerEffect

- BlendVOX
- CrossVOX
- DisplaceVOX
- LookupVOX


## Data

You can access the rendered voxels with `.renderedVoxels`
