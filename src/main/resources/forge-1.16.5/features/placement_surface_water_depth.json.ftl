$if (!(world.getHeight(Heightmap.Type.OCEAN_FLOOR, origin.getX(), origin.getZ()) - world.getHeight(Heightmap.Type.WORLD_SURFACE, origin.getX(), origin.getZ()) <= ${field$depth}))
  return false;$
