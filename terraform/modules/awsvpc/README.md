# there has some problem after private subnet create, they dont take a tag on route table, u have to use other hack way to inject VAR  


- https://github.com/hashicorp/terraform-provider-external/issues/56
- https://stackoverflow.com/questions/69004621/is-there-any-way-for-external-data-sources-to-find-if-this-is-a-plan-apply-or-d

# have to use bash jq return json format terrform 

# when u use for_each in resource ,U cant Ref the attribute, have to loop the first by Count anyway