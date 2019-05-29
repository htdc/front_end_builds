import Ember from 'ember';

export default Ember.Route.extend({
  actions: {
    openPubkeyForm: function() {
      this.controller.setProperties({
        isAdding: true,
        newPubkey: this.store.createRecord('pubkey')
      });
    },

    save: function(pubkey) {
      var router = this;

      pubkey.save()
        .then(function() {
          router.refresh();
          router.send('hideAddForm');
        });
    },

    hideAddForm: function() {
      this.controller.set('isAdding', undefined);
    },

    openRemoveModal: function(pubkey) {
      this.controllerFor('pubkeys').setProperties({
        willDelete: true,
        pubkey: pubkey
      });
    },

    remove: function(pubkey) {
      var router = this;

      pubkey.destroyRecord()
        .then(function() {
          router.send('hideRemoveModal');
        });
    },

    hideRemoveModal: function() {
      this.controllerFor('pubkeys')
        .set('willDelete', undefined);
    }
  },

  model: function() {
    return this.store.find('pubkey');
  },

  setupController: function(controller, pubkeys) {
    controller.set('pubkeys', pubkeys);

    if (pubkeys.get('length') < 1) {
      controller.set('newPubkey', this.store.createRecord('pubkey'));
    }
  }
});
