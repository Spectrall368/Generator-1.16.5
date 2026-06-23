<@addTemplate file="utils/blockstate_props/property_from_string.java.ftl"/>
private static Direction getDirectionFromBlockState(BlockState blockState) {
	Property<?> prop = getPropertyByName(blockState, "facing");
	if (prop instanceof DirectionProperty) return blockState.get((DirectionProperty) prop);
	prop = getPropertyByName(blockState, "axis");
	return prop instanceof EnumProperty && ((EnumProperty) prop).getAllowedValues().toArray()[0] instanceof Direction.Axis ?
		Direction.getFacingFromAxisDirection((Direction.Axis) blockState.get((EnumProperty) prop), Direction.AxisDirection.POSITIVE) : Direction.NORTH;
}