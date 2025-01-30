{
	final Vector3d _center = new Vector3d(${input$x}, ${input$y}, ${input$z});
	List<Entity> _entfound = world.getLoadedEntitiesWithinAABB(Entity.class, new AxisAlignedBB(_center, _center).grow(${input$range} / 2d), e -> true)
		.stream().sorted(Comparator.comparingDouble(_entcnd -> _entcnd.getDistanceSq(_center))).collect(Collectors.toList());
	for (Entity entityiterator : _entfound) {
		${statement$foreach}
	}
}
