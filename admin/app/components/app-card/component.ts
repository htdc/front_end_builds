import Component from '@glimmer/component';
import { computed, get } from '@ember/object';
import { isPresent } from '@ember/utils';
import App from 'admin/models/app';

type AppArgs = {
  app: App;
};

export default class AppCard extends Component<AppArgs> {
  @computed('app.liveBuild')
  get titleClass() {
    const app = get(this.args, 'app');
    const liveBuild = get(app, 'liveBuild');
    if (isPresent(liveBuild && liveBuild.get('id'))) {
      return 'green';
    }
    return 'grey';
  }
}
