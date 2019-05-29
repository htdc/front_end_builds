export default function() {
  this.transition(
    this.hasClass('animate-sliding-down'),
    this.toModel(true),
    this.use('fade', { duration: 300 }),
    this.reverse('fade', { duration: 300 })
  );
}
