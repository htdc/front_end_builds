import { computed } from '@ember/object';
import { sort } from '@ember/object/computed';
import Component from '@ember/component';
import Build from 'admin/models/build';

export default class AppBuildPage extends Component {
  @sort('app.builds', 'sortDefinition') sortedBuilds!: Build[];
  sortDirection = 'desc';
  sortProperty = 'createdAt';

  @computed('sortDirection', 'sortProperty')
  get sortDefinition() {
    return [`${this.sortProperty}:${this.sortDirection}`]
  }
}
