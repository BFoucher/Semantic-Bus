module.exports = {
  technicalComponentDirectory: require('./technicalComponentDirectory.js'),
  mLabPromise: require('./mLabPromise'),
  getInsertPromise: function(entityToInsert) {
    var module = this.technicalComponentDirectory[entityToInsert.module];
    //console.log(entityToInsert);
    if (entityToInsert.specificData == undefined) {
      entityToInsert.specificData = {};
    }
    if (module.initComponent != undefined) {
      entityToInsert = module.initComponent(entityToInsert);
    }
    entityToInsert.connectionsAfter = entityToInsert.connectionsAfter || [];
    entityToInsert.connectionsBefore = entityToInsert.connectionsBefore || [];

    //console.log(entityToInsert);
    return this.mLabPromise.request('POST', 'workspaceComponent', entityToInsert);
  },
  getReadPromise: function(entityIdToRead) {
    //console.log(entityToInsert);
    return this.mLabPromise.request('GET', 'workspaceComponent');
  }
}
