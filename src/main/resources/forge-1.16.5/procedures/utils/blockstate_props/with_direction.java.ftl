private static BlockState blockStateWithDirection(BlockState blockState, Direction newValue) {
	Property<?> prop = blockState.getBlock().getStateContainer().getProperty("facing");
	if (prop instanceof DirectionProperty && ((DirectionProperty) prop).getAllowedValues().contains(newValue)) return blockState.with((DirectionProperty) prop, newValue);
	prop = blockState.getBlock().getStateContainer().getProperty("axis");
	return prop instanceof EnumProperty && ((EnumProperty) prop).getAllowedValues().contains(newValue.getAxis()) ? blockState.with((EnumProperty) prop, newValue.getAxis()) : blockState;
}