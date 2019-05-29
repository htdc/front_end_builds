import Model from 'ember-data/model';
import attr from 'ember-data/attr';


export default class PublicKey extends Model {
  @attr('string') name!: string;
  @attr('string') pubKey!: string;
  @attr('string') fingerprint!: string;
  @attr('date') lastUsedAt?: Date;
}

// DO NOT DELETE: this is how TypeScript knows how to look up your models.
declare module 'ember-data/types/registries/model' {
  export default interface ModelRegistry {
    'public-key': PublicKey;
  }
}
