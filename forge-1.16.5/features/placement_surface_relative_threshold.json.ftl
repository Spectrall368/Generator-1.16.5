if (!((world.getHeight(Heightmap.Type.${field$heightmap}, placePos.getX(), placePos.getZ()) + ${field$min}) <= placePos.getY() && placePos.getY() <= (world.getHeight(Heightmap.Type.${field$heightmap}, placePos.getX(), placePos.getZ()) + ${field$max})))
  return false;
