import Component from '@glimmer/component';
import { sort } from '@ember/object/computed';
import App from 'admin/models/app';

type IndexArgs = {
  apps: App[]
}

export default class AppIndexPage extends Component<IndexArgs> {
  sortDefinition = ['name:asc'];
  @sort('args.apps', 'sortDefinition') sortedApps!: App[];
}
