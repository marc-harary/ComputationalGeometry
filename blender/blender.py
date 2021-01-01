"""
USAGE: blender --background --python blender.py --  program_options
e.g., blender --background --python blender.py -- --filepath=out.obj --solid=cube
"""

import argparse
import bpy
import sys
from ast import literal_eval


def main():
    bpy.ops.object.delete(use_global=False)

    if '--' in sys.argv:
        argv = sys.argv[sys.argv.index('--') + 1:]
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--filepath', type=str)
    parser.add_argument('--solid', type=str)
    parser.add_argument('--scale', default='1,1,1', type=str)
    parser.add_argument('--location', default='0,0,0', type=str)
    parser.add_argument('--radius', default=1, type=int)
    parser.add_argument('--depth', default=2, type=int)
    parser.add_argument('--radius1', default=1, type=int)
    parser.add_argument('--radius2', default=0, type=int)
    parser.add_argument('--major_radius', default=1, type=int)
    parser.add_argument('--minor_radius', default=0.25, type=int)
    parser.add_argument('--abso_major_rad', default=1.25, type=int)
    parser.add_argument('--abso_minor_rad', default=0.75, type=int)
    parser.add_argument('--size', default=2, type=int)
    args = parser.parse_known_args(argv)[0]
    
    args.scale = literal_eval("("+args.scale+")")
    args.location = literal_eval("("+args.location+")")
    
    defaults = dict(scale=args.scale, enter_editmode=False, align='WORLD', location=args.location)
    if args.solid == 'ball':
        bpy.ops.object.metaball_add(type='BALL', **defaults)
    elif args.solid == 'capsule':
        bpy.ops.object.metaball_add(type='CAPSULE', **defaults)
    elif args.solid == 'plane':
         bpy.ops.object.metaball_add(type='PLANE', **defaults)
    elif args.solid == 'ellipsoid':
        bpy.ops.object.metaball_add(type='ELLIPSOID', **defaults)
    elif args.solid == 'round_cube':
        bpy.ops.object.metaball_add(type='CUBE', **defaults)
    elif args.solid == 'cube':
        bpy.ops.mesh.primitive_cube_add(**defaults)
    elif args.solid == 'uvSphere':
        bpy.ops.mesh.primitive_uv_sphere_add(**defaults)
    elif args.solid == 'ico_sphere':
        bpy.ops.mesh.primitive_ico_sphere_add(**defaults)
    elif args.solid == 'cylinder':
        bpy.ops.mesh.primitive_cylinder_add(radius=args.radius, depth=args.depth, **defaults)
    elif args.solid == 'cone':
        bpy.ops.mesh.primitive_cone_add(radius1=args.radius1, radius2=args.radius2, depth=args.depth, **defaults)
    elif args.solid == 'torus':
        bpy.ops.mesh.primitive_torus_add(major_radius=args.major_radius, minor_radius=args.minor_radius,
                                         abso_major_rad=args.abso_major_rad, abso_minor_rad=args.abso_minor_rad,
                                         **defaults)
    elif args.solid == 'nurbs_sphere':
        bpy.ops.surface.primitive_nurbs_surface_sphere_add(radius=args.radius, **defaults)
    elif args.solid == 'nurbs_cylinder':
        bpy.ops.surface.primitive_nurbs_surface_cylinder_add(radius=args.radius, **defaults)
    elif args.solid == 'nurbs_torus':
        bpy.ops.surface.primitive_nurbs_surface_torus_add(radius=args.radius, **defaults)
    elif args.solid == 'monkey':
        bpy.ops.mesh.primitive_monkey_add(size=args.size)
    elif args.solid == 'text':
        bpy.ops.object.text_add(**defaults)
    else:
        raise ValueError
    
    bpy.ops.export_scene.obj(filepath=args.filepath)
       
        
if __name__ == '__main__':
    main()