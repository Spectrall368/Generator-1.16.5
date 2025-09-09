$if(!(
  <#if field_list$x?size != 0>
    <#list 0..field_list$x?size-1 as i>
    (origin.getX() == ${field_list$x[i]} && origin.getY() == ${field_list$y[i]} && origin.getZ() == ${field_list$z[i]})
    <#sep> ||</#list>
  <#else>false</#if>
  ))
return false;$