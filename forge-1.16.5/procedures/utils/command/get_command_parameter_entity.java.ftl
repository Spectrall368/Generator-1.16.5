private static Entity commandParameterEntity(CommandContext<CommandSource> arguments, String parameter) {
	try {
		return EntityArgument.getEntity(arguments, parameter);
	} catch (CommandSyntaxException e) {
		e.printStackTrace();
		return null;
	}
}