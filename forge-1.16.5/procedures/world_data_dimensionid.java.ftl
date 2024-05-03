(world instanceof World ? ((World) world).getDimensionKey() : (world instanceof ISeedReader ? ((ISeedReader) world).getWorld().getDimensionKey() : World.OVERWORLD))
