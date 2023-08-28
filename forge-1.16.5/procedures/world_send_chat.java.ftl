if (!world.isRemote() && world.getServer() != null)
	world.getServer().getPlayerList().func_232641_a_(new StringTextComponent(${input$text}), ChatType.SYSTEM, Util.DUMMY_UUID);
