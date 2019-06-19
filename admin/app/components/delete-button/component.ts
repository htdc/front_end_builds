import Component from '@glimmer/component';
import { dropTask } from 'ember-concurrency-decorators';
import DS from 'ember-data';

export default class DeleteButton extends Component {
  @dropTask
  deleteKey = function*(target: DS.Model) {
    yield target.destroyRecord();
  };
}
