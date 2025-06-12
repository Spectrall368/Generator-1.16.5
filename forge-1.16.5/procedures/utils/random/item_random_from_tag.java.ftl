private static Item getRandomItem(ResourceLocation name) {
		ITag<Item> tag = ItemTags.getCollection().getTagByID(name);
		return tag.getAllElements().isEmpty() ? Items.AIR : tag.getRandomElement(new Random());
}