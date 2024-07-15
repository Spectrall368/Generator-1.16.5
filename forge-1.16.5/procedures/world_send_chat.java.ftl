if (!world.isRemote() && world instanceof ServerWorld && ((ServerWorld) world).getServer() != null) world.getServer().getPlayerList().sendMessage(new StringTextComponent(${input$text}));
