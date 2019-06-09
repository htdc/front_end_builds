import { helper } from '@ember/component/helper';
import { formatDistance } from 'date-fns';

export function relativeTime([date]: [Date]) {
  if (!date) {
    return '';
  }
  return formatDistance(date, new Date(), { addSuffix: true });
}

export default helper(relativeTime);
