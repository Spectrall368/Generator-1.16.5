private static String commandParameterMessage(CommandContext<CommandSource> arguments, String parameter) {
	try {
		return MessageArgument.getMessage(arguments, parameter).getString();
	} catch (CommandSyntaxException e) {
		e.printStackTrace();
		return "";
	}
}