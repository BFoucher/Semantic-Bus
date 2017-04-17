function CacheNosqlStore() {
  riot.observable(this) // Riot provides our event emitter.

  this.on('item_current_reloadCache', function(data) {
    console.log('item_current_reloadCache', data);
    console.log(this.genericStore);
    $.ajax({
      method: 'get',
      url: '../data/specific/reloadcache/' + this.genericStore.itemCurrent._id.$oid ,
      contentType: 'application/json'
    }).done(function(data) {
      console.log(data);
    }.bind(this));
  });
}