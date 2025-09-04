if (!world.isRemote() && ((ServerWorld) world).getServer() != null)
	((ServerWorld) world).getServer().getPlayerList().func_232641_a_(new StringTextComponent(${input$text}), ChatType.SYSTEM, Util.DUMMY_UUID);
