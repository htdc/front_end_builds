import { helper } from '@ember/component/helper';
import { format } from 'date-fns';

export function formatDate([date]: [Date?], { formatString }: { formatString?: string }) {
  if (!date) { return ''; }
  return format(date, formatString || 'MMM do yyyy')
}

export default helper(formatDate);
