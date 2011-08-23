Seamless Database Pool for Engineyard Master/Slave Setup
===============

So you have multiple database instances on Engineyard and you want to use the additional instances for reads, but you dont know where to start? Google "master slave engineyard" sometime. Report back if you ever find anything useful beyond this post about [Using Masochism](http://blog.andrewvc.com/using-masochism-multiple-db-support-with-engi) which is very helpful if you never plan to expand beyond a single slave.

1. Install the [seamless database pool plugin](https://github.com/bdurand/seamless_database_pool) and follow the setup instructions, making sure to include the appropriate code in your ApplicationController.
  {% codeblock %}
    class ApplicationController < ActionController::Base
      include SeamlessDatabasePool::ControllerFilter
      use_database_pool :all => :persistent, [:create, :update, :destroy] => :master
    end
  {% endcodeblock %}
1. Add the extra N instances of database slaves to your EngineYard environment.
1. Grab my [seamless_database_pool cookbook](https://github.com/jerrod/ey-chef-seamless_database_pool) from github and add to your cookbooks directory. I am not 100% sure this is correct or accepted, but i like to keep my cookbooks with the app they are associated with, so i have a /cookbooks directory at the root of my applicaton. you will want to rename it "seamless_database_pool". i added ey-chef- to make it easier to find.
1. Add the seamless_database_pool recipe to you main cookbook at /cookbooks/main/recipes/default.rb
  {% codeblock %}
    require_recipe "seamless_database_pool"
  {% endcodeblock %}
1. Add the following to your /deploy/before_migration.rb
  {% codeblock %}
    run "ln -nfs #{release_path}/config/database_cluster.yml  #{release_path}/config/database.yml"
  {% endcodeblock %}
1. Commit and push everything
1.  Load the recipe onto your environment via the [engineyard cli](https://github.com/engineyard/engineyard), waiting
  {% codeblock %}
    $ ey recipes upload
    $ ey recipes apply
    $ ey deploy
  {% endcodeblock %}
1. Hammer your server with your performance testing tool (I recommend [Siege](http://www.joedog.org/index/siege-home)) and verify that the slaves are getting read requests. The "Graphs" for the instances is a great place to verify without SSH Spelunking.

Got a better way? See something wrong?  Let me know below.
